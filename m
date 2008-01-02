From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Jan  2 19:03:30 2008
Subject: [Ocfs2-devel] Re: [Ocfs2-tools-devel] [PATCH 3/6] Abstract checking
 and validating process in tunefs.ocfs2.take 3
In-Reply-To: <20071218011317.GA23447@tma-pc1.cn.oracle.com>
References: <20071218011317.GA23447@tma-pc1.cn.oracle.com>
Message-ID: <477C501F.3010309@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> In the main function of tunefs.ocfs2, there are a large
> number of checking and validating process. They are seperated
> and can be moved out of "main" so that future online resize
> can skip these check easily. So add 2 new function, volume_check
> and validate_parameter to organize the complicated process.
>
> There are also 2 minor changes in this patch:
> 1. the print of "Adding backup superblock for the volume" are moved to
>    validate process as others.
> 2. remove_slot_check is moved into function volume_check as it does
>    the check work while it was in validate process.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> --
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Remind me... some of the error messages need some polishing.
Nothing big. I can handle that later.
