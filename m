From: piaojun <piaojun@huawei.com>
Date: Thu, 25 Oct 2018 18:31:15 +0800
Subject: [Ocfs2-devel] [RFC PATCH 0/5] ocfs2: support IPv6 communication in
	o2cb cluster
Message-ID: <5BD19B73.7050607@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2cb cluster only support IPv4 node configuration nowadays. Along with IPv6
used more widely, ocfs2 should also keep up with the pace. This patch
series add configfs attribute for IPv6 configure and build connnection
between nodes with IPv6 socket. So the nodes in cluster could send dlm
messages through IPv6 network protocol.

Jun Piao (5):
  ocfs2/cluster: add configfs attributes for IPv6 address and port
  ocfs2/cluster: implement show & store method for IPv6 attribute
  ocfs2/cluster: support IPv6 socket connection between nodes
  ocfs2/dlm: modify message DLM_QUERY_NODEINFO to adapt IPv6 node
  ocfs2/cluster: modify socket container macro to adapt IPv6

 cluster/nodemanager.c |  157 +++++++++++++++++++-----
 cluster/nodemanager.h |   11 +
 cluster/tcp.c         |  323 ++++++++++++++++++++++++++++++++++++--------------
 cluster/tcp.h         |    2
 dlm/dlmcommon.h       |   12 +
 dlm/dlmdomain.c       |   93 ++++++++++----
 6 files changed, 450 insertions(+), 148 deletions(-)
