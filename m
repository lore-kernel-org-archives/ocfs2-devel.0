From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 5 Mar 2009 15:30:27 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: reserve xattr block for
	new	directory with inline data
In-Reply-To: <49AF443A.4040305@oracle.com>
References: <49AF40A9.8050601@oracle.com>
	<1236222358-10447-1-git-send-email-tiger.yang@oracle.com>
	<49AF443A.4040305@oracle.com>
Message-ID: <20090305233027.GB27682@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 05, 2009 at 11:17:14AM +0800, Tao Ma wrote:
> Hi tiger,
> 	I guess Joel's idea is that you add comment above the code. Not in the 
> commit log. ;)

	The commit log is good, but the comment should also be added to
the code.  Tao is right that's what I was asking for :-)  You'll note
that the comment above the if() describes the cases in which we skip
inline xattrs.  You've added another reason to skip inline xattrs, so
that comment should include your reason.
	Literally, cut and past your commit log into that comment block.

Joel

-- 

"The question of whether computers can think is just like the question
 of whether submarines can swim."
	- Edsger W. Dijkstra

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
