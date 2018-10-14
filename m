From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 14 Oct 2018 10:37:38 -0700
Subject: [Ocfs2-devel] [PATCH 11/25] vfs: pass remap flags to
 generic_remap_file_range_prep
In-Reply-To: <153938921860.8361.1983470639945895613.stgit@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
	<153938921860.8361.1983470639945895613.stgit@magnolia>
Message-ID: <20181014173738.GA6400@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

> +	bool is_dedupe = (remap_flags & RFR_SAME_DATA);

Btw, I think the code would be cleaner if we dropped this variable.
