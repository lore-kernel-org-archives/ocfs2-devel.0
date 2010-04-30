From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 30 Apr 2010 13:37:53 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
	to buffered v3
In-Reply-To: <20100426222423.GJ17377@mail.oracle.com>
References: <201004171749.10674.lidongyang@novell.com>
	<20100426222423.GJ17377@mail.oracle.com>
Message-ID: <20100430203753.GC24797@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 26, 2010 at 03:24:23PM -0700, Joel Becker wrote:
> On Sat, Apr 17, 2010 at 05:49:10PM +0800, Li Dongyang wrote:
> > when we fall back to buffered write from direct write, we call
> > __generic_file_aio_write but that will end up doing direct write
> > even we are only prepared to do buffered write because the file
> > has O_DIRECT flag set. This is a fix for
> > https://bugzilla.novell.com/show_bug.cgi?id=591039
> > revised with Joel's comments.
> > 
> > Signed-off-by: Li Dongyang <lidongyang@novell.com>
> 
> 	This looks good to me.  I'd like Mark's ack before I push it to
> merge-window.

Looks good to me. Nice catch on the backing_dev_info bits.

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
