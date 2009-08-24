From: TaoMa <tao.ma@oracle.com>
Date: Tue, 25 Aug 2009 07:11:51 +0800
Subject: [Ocfs2-devel] [PATCH 00/41] ocfs2: Add reflink file support. V4
In-Reply-To: <20090821012448.GH10558@mail.oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<20090821012448.GH10558@mail.oracle.com>
Message-ID: <4A931E37.8040202@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
Joel Becker wrote:
> On Tue, Aug 18, 2009 at 02:19:11PM +0800, Tao Ma wrote:
>   
>> Hi all,
>>     So I have finally finished the v4 of reflink for ocfs2. Great
>> thanks for Joel's review.
>>     
>
> 	Ok, I'm done with the review.  I basically skimmed or skipped
> all the patches I already liked.  You didn't change anything outside of
> responding to reviews of v3, right?
> 	We're in great shape.  Hopefully you'll be able to answer my
> questions and comments tomorrow and we can get this sucker into
> merge-window Monday or Tuesday!
>   
I have sent updated 17 and 19 patches. Please review.

btw I have also done some minor change(add the comments and add an error 
checker) etc and push the latest one into
my git tree in git://oss.oracle.com/git/tma/linux-2.6.git refcount.
So do I need to re-send the whole patch set or you can just pull from my 
tree?

Regards,
Tao
