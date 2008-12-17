From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Dec 2008 11:18:11 -0800
Subject: [Ocfs2-devel] [PATCH 3/9] ocfs2: Exposes the file system state
 via debugfs
In-Reply-To: <20081217011601.GB8791@wotan.suse.de>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
	<1229471363-15887-4-git-send-email-sunil.mushran@oracle.com>
	<20081217011601.GB8791@wotan.suse.de>
Message-ID: <49495073.7030105@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> A lot of the above seems a bit like overkill to me. Couldn't we just get
> this stuff with 'mount' and 'debugfs.ocfs2'?
>   

We could. However, this info is useful because it could be captured
automatically by oswatcher.

> Also, I wonder if it's not a bad idea to split out the important stuff into
> their own files.
>   

That would be useful once we have more information to provide.
Right now I like the symmetry between the dlm_state and fs_state...
like the two locking state(s).

> Same comment regarding generic_file_llseek() here.
>   

Working on it.
