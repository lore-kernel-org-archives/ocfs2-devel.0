From: Gang He <ghe@suse.com>
Date: Wed, 20 Mar 2019 04:06:49 -0600
Subject: [Ocfs2-devel] o2locktop introduction
Message-ID: <5C9210B9020000F90005A166@prv1-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Guys,

We wrote a tool with Python, which is used to display DLM lock usages in a OCFS2 cluster.
o2locktop is a top-like OCFS2 DLM lock monitor, it displays DLM lock usages via querying OCFS2 file system statistics from the specified nodes. 
Therefore, OCFS2 kernel modules must enable OCFS2_FS_STATS configuration option when compiling.
If you want to know if the current OCFS2 kernel modules enable OCFS2_FS_STATS setting, you can refer to /boot/config-`uname -r` file.
You can utilize o2locktop to detect the hot files/directories, whose DLM locks are frequently referenced among the cluster.
You can get the maximal wait time per DLM lock, this helps you identify which hot files/directories should be decoupled for improving file access performance.
For more details, please visit the link https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_ganghe_o2locktop&d=DwIFAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=dIyBOATWkOFIZSDbrxqrVXMULmozcs1_3pnbkuS6En8&s=LWmVy9gb46kbYzDAa_-tHbfV36_0Hhcj11xCnMUiUxQ&e= 
This tool is expected to be used for SUSE customer, if you are interested, welcome to use, to contribute, suggestions, etc. 

Thanks a lot.
Gang
