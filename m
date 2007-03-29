From: Fabio Massimo Di Nitto <fabbione@ubuntu.com>
Date: Thu Mar 29 02:04:50 2007
Subject: [Ocfs2-devel] [PATCH 0/3] Properly protect the extent map
In-Reply-To: <20070329005041.518030000@oracle.com>
References: <20070329005041.518030000@oracle.com>
Message-ID: <460B7B00.30004@ubuntu.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> The extent map code was seeing an error trip when inserting records.
> There is a sanity check ensuring that the new record is within the known
> size of the file - as known by the extent map.  The problem was that the
> "known" size was smaller than expected, returning an error to the caller.
> 
> This is a lot easier to see in local mounts.  It has only been rarely seen
> in clusters.
> 
> We have three "independant" problems.
> 
> 1) We don't take ip_alloc_sem when touching directory allocations.
> 2) We don't lock em_clusters properly.
> 3) Local mounts race to ocfs2_extent_map_trunc() in ocfs2_meta_lock_update().
> 
> The patches that follow are against mainline.  They have been tested
> against 1.2 with local mounts.
> 
> Patches (1) and (2) will be ported to the ocfs2 1.2 branch directly,
> and all three fixes will be pushed to mainline.
> 
> Joel

add a

Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>

on all 3 of them. They fix the problem as i reported it, but it looks like they
introduce a performance hit. Somebody other than me should test it too.

Fabio

-- 
I'm going to make him an offer he can't refuse.
