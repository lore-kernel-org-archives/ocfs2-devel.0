From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 24 Jan 2014 14:21:19 -0800
Subject: [Ocfs2-devel] [patch 01/11] ocfs2: fix ocfs2_sync_file()
	if	filesystem is readonly
In-Reply-To: <52E2E2E1.2060601@suse.de>
References: <20140124204700.532BA31C1B6@corp2gmr1-1.hot.corp.google.com>
	<52E2E2E1.2060601@suse.de>
Message-ID: <20140124222119.GF24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 24, 2014 at 04:02:09PM -0600, Goldwyn Rodrigues wrote:
> 
> 
> On 01/24/2014 02:46 PM, akpm at linux-foundation.org wrote:
> > From: Younger Liu <younger.liucn@gmail.com>
> > Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly
> >
> > If filesystem is readonly, there is no need to flush drive's caches or
> > force any uncommitted transactions.
> 
> An ocfs2 filesystem can be set to read-only because of an error, in 
> which case, you should return -EROFS.
> 
> Nak.

Goldwyn's right actually - disregard my sign off for the last one.

Basically the patch does this:

    if  (we're in some readonly state)
	return 0;

What we want, at the top of ocfs2_sync_file() is a return of -EROFS. This
will satisfy Goldwyn's requirement that we bubble -EROFS up the stack but at
the same time avoiding the extra work of trying to sync on a RO fs.

So the new version of the patch would be:

    if  (we're in some readonly state)
	return -EROFS;

Thanks,
	--Mark

--
Mark Fasheh
