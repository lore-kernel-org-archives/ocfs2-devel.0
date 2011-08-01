From: Jesper Juhl <jj@chaosbits.net>
Date: Mon, 01 Aug 2011 22:53:14 -0000
Subject: [Ocfs2-devel] [PATCH] Documentation/ABI/: update version number
 references from 2.6.x to 3.x
Message-ID: <alpine.LNX.2.00.1108020050190.31999@swampdragon.chaosbits.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, ocfs2-devel@oss.oracle.com, =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>, device-drivers-devel@blackfin.uclinux.org, Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org

Update the version number references from 2.6.x to 3.x
Also correct spelling of "May" (was spelled "Mai").

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 Documentation/ABI/removed/o2cb                     |    2 +-
 Documentation/ABI/testing/sysfs-bus-bcma           |    8 ++++----
 .../testing/sysfs-class-backlight-driver-adp8870   |   16 ++++++++--------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/removed/o2cb b/Documentation/ABI/removed/o2cb
index 7f5daa4..20c91ad 100644
--- a/Documentation/ABI/removed/o2cb
+++ b/Documentation/ABI/removed/o2cb
@@ -1,6 +1,6 @@
 What:		/sys/o2cb symlink
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	ocfs2-devel at oss.oracle.com
 Description:	This is a symlink: /sys/o2cb to /sys/fs/o2cb. The symlink is
 		removed when new versions of ocfs2-tools which know to look
diff --git a/Documentation/ABI/testing/sysfs-bus-bcma b/Documentation/ABI/testing/sysfs-bus-bcma
index 06b62ba..721b4ae 100644
--- a/Documentation/ABI/testing/sysfs-bus-bcma
+++ b/Documentation/ABI/testing/sysfs-bus-bcma
@@ -1,6 +1,6 @@
 What:		/sys/bus/bcma/devices/.../manuf
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	Rafa? Mi?ecki <zajec5@gmail.com>
 Description:
 		Each BCMA core has it's manufacturer id. See
@@ -8,7 +8,7 @@ Description:
 
 What:		/sys/bus/bcma/devices/.../id
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	Rafa? Mi?ecki <zajec5@gmail.com>
 Description:
 		There are a few types of BCMA cores, they can be identified by
@@ -16,7 +16,7 @@ Description:
 
 What:		/sys/bus/bcma/devices/.../rev
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	Rafa? Mi?ecki <zajec5@gmail.com>
 Description:
 		BCMA cores of the same type can still slightly differ depending
@@ -24,7 +24,7 @@ Description:
 
 What:		/sys/bus/bcma/devices/.../class
 Date:		May 2011
-KernelVersion:	2.6.40
+KernelVersion:	3.0
 Contact:	Rafa? Mi?ecki <zajec5@gmail.com>
 Description:
 		Each BCMA core is identified by few fields, including class it
diff --git a/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870 b/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
index aa11dbd..4a9c545 100644
--- a/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
+++ b/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
@@ -4,8 +4,8 @@ What:		/sys/class/backlight/<backlight>/l2_bright_max
 What:		/sys/class/backlight/<backlight>/l3_office_max
 What:		/sys/class/backlight/<backlight>/l4_indoor_max
 What:		/sys/class/backlight/<backlight>/l5_dark_max
-Date:		Mai 2011
-KernelVersion:	2.6.40
+Date:		May 2011
+KernelVersion:	3.0
 Contact:	device-drivers-devel at blackfin.uclinux.org
 Description:
 		Control the maximum brightness for <ambient light zone>
@@ -18,8 +18,8 @@ What:		/sys/class/backlight/<backlight>/l2_bright_dim
 What:		/sys/class/backlight/<backlight>/l3_office_dim
 What:		/sys/class/backlight/<backlight>/l4_indoor_dim
 What:		/sys/class/backlight/<backlight>/l5_dark_dim
-Date:		Mai 2011
-KernelVersion:	2.6.40
+Date:		May 2011
+KernelVersion:	3.0
 Contact:	device-drivers-devel at blackfin.uclinux.org
 Description:
 		Control the dim brightness for <ambient light zone>
@@ -29,8 +29,8 @@ Description:
 		this <ambient light zone>.
 
 What:		/sys/class/backlight/<backlight>/ambient_light_level
-Date:		Mai 2011
-KernelVersion:	2.6.40
+Date:		May 2011
+KernelVersion:	3.0
 Contact:	device-drivers-devel at blackfin.uclinux.org
 Description:
 		Get conversion value of the light sensor.
@@ -39,8 +39,8 @@ Description:
 		8000 (max ambient brightness)
 
 What:		/sys/class/backlight/<backlight>/ambient_light_zone
-Date:		Mai 2011
-KernelVersion:	2.6.40
+Date:		May 2011
+KernelVersion:	3.0
 Contact:	device-drivers-devel at blackfin.uclinux.org
 Description:
 		Get/Set current ambient light zone. Reading returns
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
