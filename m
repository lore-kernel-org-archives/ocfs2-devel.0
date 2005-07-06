From: Bruce Schwartz <bruce.schwartz@gmail.com>
Date: Wed Jul  6 16:20:04 2005
Subject: [Ocfs2-devel] 256 node limit
In-Reply-To: <20050706190440.GN8215@ca-server1.us.oracle.com>
References: <200507011649.j61GnMlY022352@oss.oracle.com>
	<20050701170449.GG26608@marowsky-bree.de>
	<42C5899E.2000209@oracle.com>
	<11fa5cce05070116517b7339b5@mail.gmail.com>
	<42CB1689.8040800@oracle.com>
	<11fa5cce050706103855a0470f@mail.gmail.com>
	<20050706180418.GA21089@ca-server1.us.oracle.com>
	<20050706185801.GM8215@ca-server1.us.oracle.com>
	<20050706190440.GN8215@ca-server1.us.oracle.com>
Message-ID: <11fa5cce05070614202aba490@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for all the great responses. I had only skimmed the ocfs2 code and 
hadn't looked at heartbeat, dlm, etc. so I had missed the various u8's. 
Certainly the scope of the problem is much clearer now and I'm glad to hear 
that there isn't anything particularly difficult about it (at least up to 
the point where the number of nodes would require kmalloc instead of 
allocating off the stack). There's just lots of mechanical changes get 
right.

Thanks again and I'll report back if I actually try this.

-Bruce
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20050706/f3252bc6/attachment.html
