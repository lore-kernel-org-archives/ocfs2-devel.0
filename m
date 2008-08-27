From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 27 Aug 2008 14:16:08 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2.git: Combine
	ocfs2_xattr_get_clusters to ocfs2_get_cluster.
Message-ID: <48B4F128.2060303@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
	The ocfs2_xattr_get_clusters is originally copied from 
ocfs2_get_clusters, so most of the codes are common. This patch set 
merge them together.

Regards,
Tao
