From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Tue, 20 Sep 2011 10:11:30 -0500
Subject: [Ocfs2-devel] [PATCH 0/2] Parallel Recovery v2
Message-ID: <CAJtY7HWjYuEMQ_GKmEv_EZ7FOi1KdHrRQo+EEtU8YM8uEuM1rQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is an attempt to parallelize recovery. A new structure
ocfs2_recovery_node manages the recovery and replaces the recovery
map. More details in individual patches.

Changes:
 - Use a pre-allocated list to avoid ENOMEM
 - Use work queue to offload recovery procedure
