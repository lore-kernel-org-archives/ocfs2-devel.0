From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon, 07 Jul 2008 11:34:06 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: Fixes oops in
	dlm_new_lockres()
In-Reply-To: <20080707182023.GC28100@wotan.suse.de>
References: <1215450389-7297-1-git-send-email-sunil.mushran@oracle.com>
	<20080707182023.GC28100@wotan.suse.de>
Message-ID: <4872619E.3050507@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

http://oss.oracle.com/pipermail/ocfs2-devel/2008-July/002460.html

Yes... for pushing upstream.

User reported the oops over the weekend.

Mark Fasheh wrote:
> On Mon, Jul 07, 2008 at 10:06:29AM -0700, Sunil Mushran wrote:
>   
>> Patch fixes a race that can result in an oops while adding a
>> lockres to the dlm lockres tracking list.
>>
>> Bug introduced by mainline commit 29576f8bb54045be944ba809d4fca1ad77c94165.
>>     
>
> Ok, looks good... What's the impact? This looks like perhaps I should be
> pushing up upstream asap...
> 	--Mark
>
> --
> Mark Fasheh
>   
