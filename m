From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 7 May 2012 17:34:31 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: modify reservation code to
 support discontigous localalloc
In-Reply-To: <1336432890-18638-4-git-send-email-srinivas.eeda@oracle.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
	<1336432890-18638-4-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20120508003431.GF4713@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 07, 2012 at 04:21:30PM -0700, Srinivas Eeda wrote:
> Currently reservation code assumes a bitmap given to it is all one contigous
> chunk. This patch enhances it to handle a discontigous chunks. It adds new
> fields m_bitmap_ext_cnt and m_bitmap_ext_arr. m_bitmap_ext_arr tracks the sizes
> of each contigous free bits and m_bitmap_ext_cnt trackes number of
> m_bitmap_ext_arr.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>

Hi Srini,
	A patch like this should come before the feature patch.  Once
this code can treat the old single-range bitmap as a one-element
multiple-range bitmap, you can add the multiple-range change easily.

> +void ocfs2_resmap_set_ext(struct ocfs2_reservation_map *resmap, int arr, u32 sz)
> +{
> +	if (ocfs2_resmap_disabled(resmap))
> +		return;
> +
> +	resmap->m_bitmap_ext_arr[arr] = sz;
> +}

	I don't see this function called anywhere.  And please don't use
needless abbreviations.  If you want to say ocfs2_resmap_set_extent(),
write it out.  I don't quite get the arguments, and since it isn't
called, I can't figure out how they are used.

Joel

-- 

"To announce that there must be no criticism of them president, or
 that we are to stand by the president, right or wrong, is not only
 unpatriotic and servile, but is morally treasonable to the American
 public."
	- Theodore Roosevelt

			http://www.jlbec.org/
			jlbec at evilplan.org
