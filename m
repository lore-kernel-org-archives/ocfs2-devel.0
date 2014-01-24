From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Fri, 24 Jan 2014 16:02:09 -0600
Subject: [Ocfs2-devel] [patch 01/11] ocfs2: fix ocfs2_sync_file() if
 filesystem is readonly
In-Reply-To: <20140124204700.532BA31C1B6@corp2gmr1-1.hot.corp.google.com>
References: <20140124204700.532BA31C1B6@corp2gmr1-1.hot.corp.google.com>
Message-ID: <52E2E2E1.2060601@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 01/24/2014 02:46 PM, akpm at linux-foundation.org wrote:
> From: Younger Liu <younger.liucn@gmail.com>
> Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly
>
> If filesystem is readonly, there is no need to flush drive's caches or
> force any uncommitted transactions.

An ocfs2 filesystem can be set to read-only because of an error, in 
which case, you should return -EROFS.

Nak.


-- 
Goldwyn
