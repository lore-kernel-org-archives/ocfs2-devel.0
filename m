From: tristan <tristan.ye@oracle.com>
Date: Thu, 04 Feb 2010 19:35:03 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] Ocfs2: Optimize truncting and
	punching-hole codes.
Message-ID: <4B6AB0E7.1000505@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao, Joel,


These three patches were for truncate and punching-hole optimization.

1st patch was all about optimization of truncating.

2nd patch was a fixup of bz1216, based on 1st patch

3rd patch was for optimization of punching hole, based on former 2 patches.


#1 and #2 patch has been tested well, should be a somewhat stable 
version now,
while #3 patch is a rough v1 one, still needs more tests though simple 
comparion test
and sanity check have been done. the reason why I sent it  out with 
former 2 stable ones
together is just to let it get reviewed earlier.

Joel,

Therefore, you  can only merge the  first  2 patches if things are in a 
hurry.



Regards,
Tristan.
