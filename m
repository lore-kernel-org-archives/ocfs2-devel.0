From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Apr 16 17:50:54 2004
Subject: [Ocfs2-devel] nooin merge and the 2.6 port
Message-ID: <20040416225050.GH10471@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I just landed a big change from my nooin branch which gets us --> <-- close
to no longer having the ocfs_inode structure (everything will be on
ocfs_inode_private instead). I believe I kept the 2.6 code up to date with
my changes, but please feel free to yell@me if I've broken anything :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
