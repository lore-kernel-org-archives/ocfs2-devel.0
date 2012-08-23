From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Thu, 23 Aug 2012 10:33:17 -0700
Subject: [Ocfs2-devel] RFC: OCFS2 heartbeat improvements
In-Reply-To: <5035A719.1000707@tao.ma>
References: <5034EA17.107@oracle.com>
	<5035A719.1000707@tao.ma>
Message-ID: <CAEeiSHUNXAHcRko4zYePSy=Qm3xG0haVd0Puj3oWXS5Mq8K7ZQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 22, 2012 at 8:44 PM, Tao Ma <tm@tao.ma> wrote:

> I guess the final solution will be WRITE_FUA, and I see btrfs uses it to
> write out the superblock. It will be handled differently by the
> underlying block layer so that it will not be in the elevator queue. It
> should work but I am not sure whether we need to be so aggressive. Maybe
> some test will show.
>
>
FUA is an overkill for the heartbeat data because we don't care if that data
hits the platter or not. It can stay in the device's volatile cache.
Infact, staying
in the cache, and not hitting the platter, is better.
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120823/46739e77/attachment.html 
