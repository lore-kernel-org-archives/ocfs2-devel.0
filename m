From: Bruce Schwartz <bruce.schwartz@gmail.com>
Date: Fri Jul  1 18:51:06 2005
Subject: [Ocfs2-devel] 256 node limit
In-Reply-To: <42C5899E.2000209@oracle.com>
References: <200507011649.j61GnMlY022352@oss.oracle.com>
	<20050701170449.GG26608@marowsky-bree.de>
	<42C5899E.2000209@oracle.com>
Message-ID: <11fa5cce05070116517b7339b5@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all --

In the "what's new in OCFS2" document at 
http://oss.oracle.com/projects/ocfs2/dist/documentation/ocfs2-whats-new.txtit
says that the 256 node limit is a software limit and could be lifted.
Why
is that limit there? Are there some algorithms that don't scale nicely with 
larger number of nodes? I'm guessing that there is more to it than saving a 
byte of RAM in a few data structures.

Thanks,
Bruce
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20050701/0c255206/attachment.html
