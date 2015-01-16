From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 16 Jan 2015 15:26:59 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix snprintf format specifier in
	dlmdebug.c
In-Reply-To: <54AE4E6D.6050902@huawei.com>
References: <54AE4E6D.6050902@huawei.com>
Message-ID: <20150116232659.GI20308@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 08, 2015 at 05:31:25PM +0800, alex chen wrote:
> Use snprintf format specifier "%lu" instead of "%ld" for
> argument of type 'unsigned long'.
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>


> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

Btw, did this review happen on the mailing list? It's customary for review
to happen publicly.

Thanks,
	--Mark

--
Mark Fasheh
