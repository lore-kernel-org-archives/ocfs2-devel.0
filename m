From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue Jul  5 18:23:47 2005
Subject: [Ocfs2-devel] 256 node limit
In-Reply-To: <11fa5cce05070116517b7339b5@mail.gmail.com>
References: <200507011649.j61GnMlY022352@oss.oracle.com>	<20050701170449.GG26608@marowsky-bree.de>	<42C5899E.2000209@oracle.com>
	<11fa5cce05070116517b7339b5@mail.gmail.com>
Message-ID: <42CB1689.8040800@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's actually 255. Yes, that doc needs to be updated.

No, the algorithms did not play much role in setting this limit.
Guess, can say the limit is part arbitrary, part practical.
(That extra byte adds up pretty quickly.)

Bruce Schwartz wrote:

> Hi all --
>
> In the "what's new in OCFS2" document at  
> http://oss.oracle.com/projects/ocfs2/dist/documentation/ocfs2-whats-new.txt 
> it says that the 256 node limit is a software limit and could be 
> lifted.  Why is that limit there?  Are there some algorithms that 
> don't scale nicely with larger number of nodes?  I'm guessing that 
> there is more to it than saving a byte of RAM in a few data structures.
>
> Thanks,
> Bruce
>
>------------------------------------------------------------------------
>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>  
>
