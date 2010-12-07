From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 6 Dec 2010 16:46:28 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add a new code
 'OCFS2_INFO_FREEFRAG' for o2info ioctl.
In-Reply-To: <4CD25B2A.7040909@oracle.com>
References: <1288782126-13007-1-git-send-email-tristan.ye@oracle.com>
	<1288782126-13007-2-git-send-email-tristan.ye@oracle.com>
	<20101104012949.GB14640@mail.oracle.com>
	<4CD220C9.20907@oracle.com>
	<20101104063221.GC22663@mail.oracle.com>
	<4CD25B2A.7040909@oracle.com>
Message-ID: <20101207004628.GK16687@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 04, 2010 at 03:05:14PM +0800, tristan wrote:
> #1 chunk   #2 chunk   #3 chunk    #4 chunk
> 1100       0010       0000        1100
> 
>  From above case, we found 3 real free chunks, they are:
> 
> 1st free_chunk_size = 4
> 
> 2nd free_chunk_size = 5
> 
> 3rd free_chunk_size = 2
> 
> Therefore, real_free_chunks = 3
> 
> While for the 'user-specified-chunksize' logic, we have 4 
> chunks(chunksize = 4), and only
> one(#3 chunk) was free.
> 
> Does it make sense?

	Yes.

Joel

-- 

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
