From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 18 Dec 2014 17:01:04 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove bogus check in
	dlm_process_recovery_data
In-Reply-To: <5490D357.1080506@huawei.com>
References: <5490D357.1080506@huawei.com>
Message-ID: <20141219010104.GW7238@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 17, 2014 at 08:50:31AM +0800, Joseph Qi wrote:
> In dlm_process_recovery_data, only when dlm_new_lock failed the ret
> will be set to -ENOMEM. And in this case, newlock is definitely NULL.
> So test newlock is meaningless, remove it.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Reviewed-by: Alex Chen <alex.chen@huawei.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
