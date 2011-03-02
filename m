From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 02 Mar 2011 19:27:16 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] support strictatime in ocfs2
Message-ID: <4D6E2994.1050302@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, all,

As strictatime was introduced into vfs, we must support it in ocfs2.
This two patches (one for kernel, one for tools) adding support to it 
and update the relative document in ocfs2.
Vfs set RELATIME by default at the beginning, so we need STRICTATIME to 
clear that flag, otherwise we can not always update atime.
With strictatime, the the minimum update interval is specified by 
atime_quantum,  and these two options need work together.

thanks,
tiger
