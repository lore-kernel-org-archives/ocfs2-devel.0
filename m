From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:07 2008
Subject: [Ocfs2-devel] [PATCH 11/30] ocfs2: Reserve ioctl range
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-12-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>

From: Tao Ma <tao.ma@oracle.com>

We need to reserve at least two ioctls for online-resize. Reserve a small
range of ioctls for Ocfs2 use in Documentation/ioctl-number.txt. This should
give us enough room for future growth.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Documentation/ioctl-number.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
index 5c7fbf9..c18363b 100644
--- a/Documentation/ioctl-number.txt
+++ b/Documentation/ioctl-number.txt
@@ -138,6 +138,7 @@ Code	Seq#	Include File		Comments
 'm'	00-1F	net/irda/irmod.h	conflict!
 'n'	00-7F	linux/ncp_fs.h
 'n'	E0-FF	video/matrox.h          matroxfb
+'o'	00-1F	fs/ocfs2/ocfs2_fs.h	OCFS2
 'p'	00-0F	linux/phantom.h		conflict! (OpenHaptics needs this)
 'p'	00-3F	linux/mc146818rtc.h	conflict!
 'p'	40-7F	linux/nvram.h
-- 
1.5.3.6
