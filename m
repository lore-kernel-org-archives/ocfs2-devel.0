From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 2 Feb 2015 10:56:45 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2-tools: support append direct io ro
	compat feature
Message-ID: <54CEE76D.2070709@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch set is to support append direct io ro compat feature in ocfs2
tools side.
For mkfs.ocfs2, it turns on the feature when fromatting a new volume by
default.
For tunefs.ocfs2, it supports turn on/off the feature. This is mostly
for the existing ocfs2 volume upgrade.
For fsck.ocfs2, it supports to truncate append dio orphan entry.

 fsck.ocfs2/pass4.c                |    9 ++
 include/ocfs2-kernel/ocfs2_fs.h   |   14 +++-
 include/ocfs2/ocfs2.h             |    7 ++
 libocfs2/feature_string.c         |   27 ++++++--
 libocfs2/truncate.c               |   12 +++
 tunefs.ocfs2/Makefile             |    3
 tunefs.ocfs2/feature_append_dio.c |  123 ++++++++++++++++++++++++++++++++++++++
 tunefs.ocfs2/op_features.c        |    2
 8 files changed, 188 insertions(+), 9 deletions(-)
