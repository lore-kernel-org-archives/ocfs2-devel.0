From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 02 Oct 2013 20:58:40 -0500
Subject: [Ocfs2-devel] [PATCH 3/7] Differentiate between no_controld and
 with_controld
In-Reply-To: <20131002094907.GS20001@suse.de>
References: <20130927170748.GA11716@shrek.lan> <20131002094907.GS20001@suse.de>
Message-ID: <524CCF50.5020501@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/02/2013 04:49 AM, Lars Marowsky-Bree wrote:
> On 2013-09-27T12:07:53, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
>> This is done primarily for backward compatibility. I hope we do
>> away with this sooner than later ;)
>
> I'd actually be quite happy if we could do away with this directly.
>
> Users that want to remain on an older user-space code base can always
> revert this or stick to a stable long-term kernel. That may be an
> unpopular opinion ;-)
>
> The relevant GFS2 commit seems to be
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/gfs2?id=e0c2a9aa1e68455dc3439e95d85cabcaff073666
>
>

Just to be complete, the DLM recovery callbacks were introduced in this 
commit

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/gfs2?id=60f98d1839376d30e13f3e452dce2433fad3060e

GFS2 also supports the older controld using DFL_NO_DLM_OPS flag set in 
the lockspace structure.

While I would also like the controld to be done away with: from a 
maintenance perspective.


-- 
Goldwyn
