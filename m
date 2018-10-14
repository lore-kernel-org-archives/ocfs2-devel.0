From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 14 Oct 2018 10:26:04 -0700
Subject: [Ocfs2-devel] [PATCH 19/25] vfs: implement opportunistic short
	dedupe
In-Reply-To: <153938927786.8361.10345203650384514542.stgit@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
	<153938927786.8361.10345203650384514542.stgit@magnolia>
Message-ID: <20181014172604.GH30673@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

How is RFR_SHORT_DEDUPE so different from RFR_SAME_DATA + RFR_CAN_SHORTEN
that we need another flag for it?
