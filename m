From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 9 Jun 2010 23:07:26 -0500
Subject: [Ocfs2-devel] [PATCH] Reoganize data elements to reduce memory
	footprint
In-Reply-To: <20100610005448.GC27385@mail.oracle.com>
References: <AANLkTinTCrwXLiCjOm4l7uIzjRSz-17vJLLhNaCMDFJa@mail.gmail.com>
	<20100610004509.GA27385@mail.oracle.com>
	<20100610005448.GC27385@mail.oracle.com>
Message-ID: <AANLkTil5qA5tCl5BkLFiRiM60_KrG9uPFmiChxsZXdAm@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,


On Wed, Jun 9, 2010 at 7:54 PM, Joel Becker <Joel.Becker@oracle.com> wrote:

>
> ? ? ? ?On the subject of extreme structure diets... ?ocfs2_lock_res
> uses ints for l_ro_holders and l_ex_holders. ?Do we ever have more than
> 64K holders? ?Can we squash those into u16s? ?I note that our code
> doesn't handle overflow at all, but 2^32 holders is significantly
> larger.

Good idea.

> ? ? ? ?Goldwyn, did you test this with CONFIG_OCFS2_FS_STATS and
> CONFIG_DEBUG_LOCK_ENABLED turned on or off? ?I'd be interested in that
> data too.
>

I had CONFIG_OCFS2_FS_STATS enabled and CONFIG_DEBUG_LOCK_ALLOC disabled.


-- 
Goldwyn
