From: Tao Ma <tao.ma@oracle.com>
Date: Thu Dec 13 23:55:23 2007
Subject: [Ocfs2-devel] [PATCH 2/4] Add new ioctl number for OCFS2.take 2
In-Reply-To: <20071214073744.GA26638@tma-pc1.cn.oracle.com>
Message-ID: <20071214075403.GA26690@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2 need a new ioctl number to call some ioctl.
So add it in ioctl-number.txt.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 Documentation/ioctl-number.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
index 5c7fbf9..9c47f6d 100644
--- a/Documentation/ioctl-number.txt
+++ b/Documentation/ioctl-number.txt
@@ -138,6 +138,7 @@ Code	Seq#	Include File		Comments
 'm'	00-1F	net/irda/irmod.h	conflict!
 'n'	00-7F	linux/ncp_fs.h
 'n'	E0-FF	video/matrox.h          matroxfb
+'o'	00-0F	fs/ocfs2/ocfs2_fs.h	OCFS2
 'p'	00-0F	linux/phantom.h		conflict! (OpenHaptics needs this)
 'p'	00-3F	linux/mc146818rtc.h	conflict!
 'p'	40-7F	linux/nvram.h
-- 
gitgui.0.9.0.gd794
