variable "project" {
  default = "prototype-273505"
}

variable "region" {
  default = "asia-northeast1"
}

variable "zone" {
  default = "asia-northeast1-a"
}

variable "network_name" {
  default = "prototype"
}

provider "google-beta" {
  region = var.region
  project = var.project
  credentials = file("prototype-273505-4fb6d65a8299.json")
}

// Network
// クラスタと通信する場合はこのネットワークを使用する
resource "google_compute_network" "default" {
  provider = google-beta
  name                    = var.network_name
  auto_create_subnetworks = false
}

// Subnetwork
resource "google_compute_subnetwork" "default" {
  provider = google-beta
  name                     = var.network_name
  ip_cidr_range            = "10.127.0.0/20" # クラスタ内からのアクセスはこのレンジでFW設定
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

// Cluster
resource "google_container_cluster" "tsukiji-cluster" {
  provider = google-beta
  name               = var.network_name
  location           = var.zone
  initial_node_count = 3
  # network            = google_compute_subnetwork.default.name
  # subnetwork         = google_compute_subnetwork.default.name
  network            = google_compute_network.default.self_link
  subnetwork         = google_compute_subnetwork.default.self_link

  enable_legacy_abac = true

  master_auth {
    username = ""
    password = ""
  }

  addons_config {
    istio_config {
      disabled = false
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 90"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    preemptible  = true
    machine_type = "g1-small"
  }
}

// Static IP
resource "google_compute_global_address" "ip_address" {
  provider = google-beta
  name = "prototype-static-ip"
}

// Cloud Build
# resource "google_cloudbuild_trigger" "default" {
#   provider = google-beta
#   // 実行トリガーの設定
#   trigger_template {
#     // ブランチを設定すると「このブランチにコミットがあった時」がトリガーになります
#     branch_name = "master"
#     // 連携するGitリポジトリ。後で解説します。
#     repo_name   = "github_YuitoSato_gcp-yuito-sandbox"
#   }

#   // Cloud Buildで使用したいymlファイル
#   filename = "nodejs-api/infra/staging/cloudbuild.yml"

#   // 変更を検知したいパス。今回はnodejs-api/srcコード以下に変更があったらビルドしてデプロイをする。
#   included_files = [
#     "nodejs-api/src/**"
#   ]
# }

// Firewall
resource "google_compute_firewall" "icmp" {
  provider = google-beta
  name    = "drupal-allow-icmp"
  network = google_compute_network.default.self_link

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "ssh" {
  provider = google-beta
  name    = "drupal-allow-ssh"
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "https" {
  provider = google-beta
  name    = "drupal-allow-https"
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["tsukiji-cluster"]
}
