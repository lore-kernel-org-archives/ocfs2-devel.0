From: Jan Kara <jack@suse.cz>
Date: Thu, 15 Jan 2015 11:13:10 +0100
Subject: [Ocfs2-devel] [PATCH 1/4] quota: Don't store flags for v2 quota
	format
In-Reply-To: <20150115094034.GA32651@infradead.org>
References: <1421260031-3355-1-git-send-email-jack@suse.cz>
	<1421260031-3355-2-git-send-email-jack@suse.cz>
	<20150115094034.GA32651@infradead.org>
Message-ID: <20150115101310.GD12739@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>

On Thu 15-01-15 01:40:34, Christoph Hellwig wrote:
> On Wed, Jan 14, 2015 at 07:27:08PM +0100, Jan Kara wrote:
> > Currently, v2 quota format blindly stored flags from in-memory dqinfo on
> > disk, although there are no flags supported. Since it is stupid to store
> > flags which have no effect, just store 0 unconditionally and don't
> > bother loading it from disk.
> > 
> > Note that userspace could have stored some flags there via Q_SETINFO
> > quotactl and then later read them (although flags have no effect) but
> > I'm pretty sure noone does that (most definitely quota-tools don't and
> > quota interface doesn't have too much other users).
> 
> What about future proofing?  Current kernels can store flags on disk,
> so the best is to reserve the currently (and possibly previously)
> assigned values, and mask them out when reading from disk.
  Hum, I'm not sure I follow you. Current kernels will store any 32-bit
number user sets in flags field. So if we wanted to be 100% safe, we'd have
to just ignore that field. Which isn't currently a problem since quota code
doesn't use the field for anything (it was added just for future
extensions). But since I'm pretty certain noone actually relies on values
of that field, I though we could just get away with forcibly zeroing the
field now and if there's a need to use the field in a few years, we could
start using it.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
