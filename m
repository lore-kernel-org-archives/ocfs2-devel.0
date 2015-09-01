From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 1 Sep 2015 15:41:22 -0700
Subject: [Ocfs2-devel] ocfs2: clean up redundant NULL checks before kfree
In-Reply-To: <55E54B90.40601@huawei.com>
References: <55E54B90.40601@huawei.com>
Message-ID: <20150901224122.GJ1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 01, 2015 at 02:54:08PM +0800, Joseph Qi wrote:
> NULL check before kfree is redundant and so clean them up.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>

Thanks,

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
