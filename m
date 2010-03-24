From: Li Dongyang <dyli@novell.com>
Date: Wed, 24 Mar 2010 16:46:58 +0800
Subject: [Ocfs2-devel] Question of rejecting a downconvert
Message-ID: <201003241646.58845.dyli@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, list
I've read 
http://opendlm.sourceforge.net/cvsmirror/opendlm/docs/dlmbook_final.pdf but 
still confused, why a node can not reject a downconvert when it gets a bast in 
o2dlm?
and if we can, we could fix this bug: 
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1075
ocfs2: a busy mount point can be removed from another node
by adding a check in check_downconvert callback:
if the dentry->d_mounted is not zero, then just reject the downconvert.

Any hints? :-)
Thanks
