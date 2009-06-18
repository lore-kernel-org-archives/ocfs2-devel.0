From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 18 Jun 2009 15:48:08 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] orphan lock fixes for local mode.
Message-ID: <4A39F138.9050503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel/Srini,
	Here are 2 patches for orphan lock in local mode.
patch 1:
	In local mode, we don't need lvb, so don't init it.
patch 2:
	In local mode, orphan lock and unlock don't need to go to dlm part.

Regards,
Tao
