From: Gang He <ghe@suse.com>
Date: Thu, 12 Feb 2015 19:13:52 -0700
Subject: [Ocfs2-devel] ocfs2-tools.git is moving, ocfs2 web site plans
In-Reply-To: <20150212232625.GP21790@wotan.suse.de>
References: <20150206210203.GI21790@wotan.suse.de>
	<54D82BF4.5040408@suse.com> <20150212232625.GP21790@wotan.suse.de>
Message-ID: <54DDCE60020000F9000027E3@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,


>>> 
> On Mon, Feb 09, 2015 at 11:39:32AM +0800, zren wrote:
>> Hi Mark and all,
>> I am wondering whether this plan will also cover ocfs2-test project.
> 
> No, I kind of left it out because I forgot!
> 
> 
>> I noticed that ocfs2-test on oss.oracle.com has not any update since 
>> 2012-03-15.
>> However,there are two branches on github I found which have some 
>> updates. They are:
>> 1. pibroch/ocfs2-test: https://github.com/pibroch/ocfs2-test and
>> 2. goldwynr/ocfs2-test: https://github.com/goldwynr/ocfs2-test/tree/suse.
>> 
>> Any information about this issue is appreciated.
> 
> I'll take a look at the branches to see what's different. I'll go ahead nad
> mirror the repository on my github. If everyone would rather do development
> there, then I can help out with review, etc. Generally though ocfs2-test is
> getting even fewer updates these days than ocfs2-tools.
> 	--Mark
>
Thank for your response, for SuSe distribution, in the past days it always uses the source code from goldwynr/ocfs2-test: https://github.com/goldwynr/ocfs2-test/tree/suse.
but now, Goldwyn will take most efforts in other projects, Zhen and I will take it from him for adding some fixes, to let the whole test cases run under OpenSuSe13.2 with ocfs2-tools v1.8.3.
we forked Goldwyn's branch to https://github.com/ganghe/ocfs2-test, if you have time for review, you can look at the change logs. Or, you can fork the branch from Goldwyn, then we pull the changes to you.
Thanks
Gang

 
> --
> Mark Fasheh
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
