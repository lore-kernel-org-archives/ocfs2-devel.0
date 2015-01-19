From: Jan Kara <jack@suse.cz>
Date: Mon, 19 Jan 2015 13:34:38 +0100
Subject: [Ocfs2-devel] [PATCH 1/4] quota: Don't store flags for v2 quota
	format
In-Reply-To: <20150119091432.GA15695@infradead.org>
References: <1421260031-3355-1-git-send-email-jack@suse.cz>
	<1421260031-3355-2-git-send-email-jack@suse.cz>
	<20150115094034.GA32651@infradead.org>
	<20150115101310.GD12739@quack.suse.cz>
	<20150119091432.GA15695@infradead.org>
Message-ID: <20150119123438.GE5662@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>

On Mon 19-01-15 01:14:32, Christoph Hellwig wrote:
> On Thu, Jan 15, 2015 at 11:13:10AM +0100, Jan Kara wrote:
> >   Hum, I'm not sure I follow you. Current kernels will store any 32-bit
> > number user sets in flags field. So if we wanted to be 100% safe, we'd have
> > to just ignore that field. Which isn't currently a problem since quota code
> > doesn't use the field for anything (it was added just for future
> > extensions). But since I'm pretty certain noone actually relies on values
> > of that field, I though we could just get away with forcibly zeroing the
> > field now and if there's a need to use the field in a few years, we could
> > start using it.
> 
> Oh, I misread the code and your description.  I thought we would just
> store any potentially valid in-core flag on disk.
> 
> I guess for now the best case would be to stop storing anything, and
> then just make an educated decision if/when we need a flags field.
  Yes, that's what I do in the patch. So we are in agreement here.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
