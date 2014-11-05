From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 5 Nov 2014 13:18:07 -0800
Subject: [Ocfs2-devel] [PATCH] Remove filesize checks for sync I/O
	journal commit
In-Reply-To: <20141104155222.GA5746@shrek.lan>
References: <20141104155222.GA5746@shrek.lan>
Message-ID: <20141105211807.GC27026@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 04, 2014 at 09:52:22AM -0600, Goldwyn Rodrigues wrote:
> Filesize is not a good indication that the file needs to be synced.
> An example where this breaks is:
>  1. Open the file in O_SYNC|O_RDWR
>  2. Read a small portion of the file (say 64 bytes)
>  3. Lseek to starting of the file
>  4. Write 64 bytes
> 
> If the node crashes, it is not written out to disk because this
> was not committed in the journal and the other node which reads
> the file after recovery reads stale data (even if the write on
> the other node was successful)

This patch looks good, thanks for sending it over.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
