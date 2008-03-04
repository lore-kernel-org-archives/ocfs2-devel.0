From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue Mar  4 13:57:26 2008
Subject: [Ocfs2-devel] [PATCH 4/6] ocfs2/dlm: Move
	struct	dlm_master_list_entry to dlmcommon.h
In-Reply-To: <20080304215436.GN9349@ca-server1.us.oracle.com>
References: <1204409065-10953-1-git-send-email-sunil.mushran@oracle.com>
	<1204409065-10953-5-git-send-email-sunil.mushran@oracle.com>
	<20080303021806.GE6897@mail.oracle.com>
	<47CC451E.1050908@oracle.com>
	<20080304215436.GN9349@ca-server1.us.oracle.com>
Message-ID: <47CDC5BF.5050005@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ok. I'll push #4 with the next series.

Mark Fasheh wrote:
> On Mon, Mar 03, 2008 at 10:36:14AM -0800, Sunil Mushran wrote:
>   
>> Was trying to balance out the number of patches in both. :)
>> I mean I wanted this cleanup irrespective of the debugfs series.
>>     
>
> I applied these patches sans #4 and things seemed ok. Should the end result
> be acceptable? I think everything except this patch looks like 2.6.25
> material...
> 	--Mark
>
> --
> Mark Fasheh
> Principal Software Developer, Oracle
> mark.fasheh@oracle.com
>   
