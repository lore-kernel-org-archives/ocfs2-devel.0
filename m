From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 23 Jun 2010 17:55:37 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <AANLkTilj3GhmxKpZ9C5QSh6w7BRYjmU-KQ6hcnSsw6gX@mail.gmail.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
	<20100623004937.GB20090@mail.oracle.com>
	<AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
	<20100623013633.GC20090@mail.oracle.com>
	<AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>
	<20100624001437.GF20090@mail.oracle.com>
	<AANLkTilj3GhmxKpZ9C5QSh6w7BRYjmU-KQ6hcnSsw6gX@mail.gmail.com>
Message-ID: <20100624005537.GG20090@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 23, 2010 at 05:45:13PM -0700, Patrick J. LoPresti wrote:
> Oh, one trivial thing I forgot to mention:  I changed the errno for
> the failure cases from EINVAL to EFBIG since that is what ext4 uses.

	That's fine.

> My next step will be to test this...  But what is next after that?  Do
> I send this as a "[PATCH] ..." to ocfs2-devel and linux-kernel, or do
> I just send to ocfs2-devel and one of you passes it on?

	Yes, you send it as a [PATCH] to ocfs2-devel and linux-kernel.
It will still go through me, but we want the process to be followed.

> +/* Check to make sure entire volume is addressable on this system. */
> +static int ocfs2_check_addressable(struct ocfs2_super *osb,
> +				   struct ocfs2_dinode *di)
> +{
> +	int status = 0;
> +	const u32 clusters = le32_to_cpu(di->i_clusters);
> +	const u64 max_block = ocfs2_clusters_to_blocks(osb->sb, clusters) - 1;

	These don't need to be const.  Sure, they don't change, but
you're not signifying anything special with them (like passing them to a
subfunction or something).  And you don't really need the clusters
temporary.

	u64 max_block =
		ocfs2_clusters_to_blocks(osb->sb,
					 le32_to_cpu(di->i_clusters)) - 1;

Joel

-- 

 The herd instinct among economists makes sheep look like
 independent thinkers.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
