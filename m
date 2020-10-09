From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 9 Oct 2020 10:18:01 -0400
Subject: [Ocfs2-devel] [PATCH 5/7] btrfs: Promote to unsigned long long
	before shifting
In-Reply-To: <20201004180428.14494-6-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
	<20201004180428.14494-6-willy@infradead.org>
Message-ID: <b36885cc-0c4b-ee03-bcd3-56f94800d84e@toxicpanda.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.com, stable@vger.kernel.org

On 10/4/20 2:04 PM, Matthew Wilcox (Oracle) wrote:
> On 32-bit systems, this shift will overflow for files larger than 4GB.
> 
> Cc: stable at vger.kernel.org
> Fixes: df480633b891 ("btrfs: extent-tree: Switch to new delalloc space reserve and release")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
