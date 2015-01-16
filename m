From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 16 Jan 2015 15:21:07 -0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: add a mount option
	journal_async_commit on	ocfs2 filesystem
In-Reply-To: <54ACAFA5.3080508@huawei.com>
References: <54ACAFA5.3080508@huawei.com>
Message-ID: <20150116232107.GH20308@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 07, 2015 at 12:01:41PM +0800, alex chen wrote:
> Add a mount option to support JBD2 feature:
> JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT. When this feature is opened,
> journal commit block can be written to disk without waiting for
> descriptor blocks, which can improve journal commit performance. This
> option will enable 'journal_checksum' internally.
> 
> Using the fs_mark benchmark, using journal_async_commit shows a 50%
> improvement, the files per second go up from 215.2 to 317.5.
> 
> test script:
> fs_mark  -d  /mnt/ocfs2/  -s  10240  -n  1000
> 
> default:
> FSUse%        Count         Size    Files/sec     App Overhead
>      0         1000        10240        215.2            17878
> 
> with journal_async_commit option:
> FSUse%        Count         Size    Files/sec     App Overhead
>      0         1000        10240        317.5            17881
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Signed-off-by: Weiwei Wang <wangww631@huawei.comm>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark
 
--
Mark Fasheh
