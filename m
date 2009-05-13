From: Oleg Gawriloff <barzog@telecom.by>
Date: Wed, 13 May 2009 12:45:00 +0300
Subject: [Ocfs2-devel] add error check for ocfs2_read_locked_inode() call
In-Reply-To: <4A0A084C.4040402@oracle.com>
References: <4A096203.2040806@telecom.by> <4A0A084C.4040402@oracle.com>
Message-ID: <4A0A969C.60400@telecom.by>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran ?????:
> I went thru the relevant code in 2.6.29-3. There has to be another
> message. That is, other than the one listed.
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=blob;f=fs/ocfs2/inode.c;h=229e707bc050629c0ad372b14c75194bf4b97f3d;hb=e18346d68f807c62bb8e5de0f809d3a1a2f093de 
> Did you modify the code? Apply some patches?
Nope. Standard vanilla-sources 2.6.29.3 on gentoo. No patches/modifies.
barzog at falcon-cl3 ~ $ ls -l /usr/src/linux/fs/ocfs2/inode.c
-rw-r--r-- 1 root root 37345 ??? 24 01:12 /usr/src/linux/fs/ocfs2/inode.c
If needed I can give you access to this server.
