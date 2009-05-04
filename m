From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 04 May 2009 12:30:17 -0700
Subject: [Ocfs2-devel] Deadlock in dlmmaster.c
In-Reply-To: <ef67228d0905031333i782ad1efhe532cd555e58b604@mail.gmail.com>
References: <ef67228d0905031333i782ad1efhe532cd555e58b604@mail.gmail.com>
Message-ID: <49FF4249.7030907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kucera <xatrix101@gmail.com>
Cc: mfasheh@suse.com, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Jan Kucera wrote:
> I've found some possible deadlock in fs/ocfs2/dlm/dlmmaster.c - 
> version 2.6.28 (probably this code is in newer versions too).
> Could someone confirm this? Thank you.
>
>
> fs/ocfs2/dlm/dlmmaster.c
> ==================
>
> function dlm_master_request_handler: (res->spinlock <- dlm->master_lock)
> -----------------------------------
> spin_lock(&res->spinlock); at line 1427
> spin_lock(&dlm->master_lock); at line 1475
>
> function dlm_migrate_request_handler: (dlm->master_lock <- res->spinlock)
> -------------------------------------------------------
> spin_lock(&dlm->master_lock) at line 3036
> spin_lock(&res->spinlock); at line 3039

So this should not happen.

The first condition can only be hit if the resource has no master and is in
the process of being mastered.

The second condition will only be hit if the resource has a master and is
currently being migrated (remastered) from one node to another.

The two appear to be mutually exclusive. But feel free to file a bugzilla
so that I remember to look into it more carefully when I have more time.
http://oss.oracle.com/bugzilla

Thanks
Sunil
