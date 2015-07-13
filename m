From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 13 Jul 2015 08:54:28 +0800
Subject: [Ocfs2-devel] [PATCH 1/2 v2] ocfs2: fix race between dio and
 recover orphan
In-Reply-To: <55A2C9A6020000D40006F887@relay2.provo.novell.com>
References: <559FAA0E.8090005@huawei.com>
	<55A2C9A6020000D40006F887@relay2.provo.novell.com>
Message-ID: <55A30C44.3090006@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/7/12 18:10, Zhen Ren wrote:
> Hi Joseph,
> 
> The following added lines are same as the deleted. Is it because the unnecessary trailing whitespaces?
> 
> -	level = ocfs2_iocb_rw_locked_level(iocb);
> -	ocfs2_rw_unlock(inode, level);
> +		level = ocfs2_iocb_rw_locked_level(iocb);
> +		ocfs2_rw_unlock(inode, level);
> 
No, I want rw unlock to be done later in case of append direct io. This
is for preventing the described race case.

> --
> Eric
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
> 
> 
