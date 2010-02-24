From: tristan <tristan.ye@oracle.com>
Date: Wed, 24 Feb 2010 16:35:21 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] Ocfs2: Add OCFS2_IOC_INFO ioctls for
	ocfs2 v6.
Message-ID: <4B84E4C9.9050201@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Joel.

That's the latest v6 o2info kernel patch, it should be mostly the same 
as 02/08 version, except for a small change which use enum instead of 
flag bits for OCFS2_IOC_INFO type codes. these 2 patches also were atop 
your latest 'fixes' kernel branch.

Please take this one as the final version for reviewing or merging.


Thanks,
Tristan.
