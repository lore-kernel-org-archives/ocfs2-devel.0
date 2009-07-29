From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 29 Jul 2009 22:28:00 +0800
Subject: [Ocfs2-devel] [PATCH 5/8] Quota support for fsck.ocfs2
In-Reply-To: <20090729100733.GD19209@duck.suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>	<1248717216-26617-6-git-send-email-jack@suse.cz>	<20090728230509.GC20595@mail.oracle.com>
	<20090729100733.GD19209@duck.suse.cz>
Message-ID: <4A705C70.8030608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,
Jan Kara wrote:
> On Tue 28-07-09 16:05:09, Joel Becker wrote:
>   
>> On Mon, Jul 27, 2009 at 07:53:33PM +0200, Jan Kara wrote:
>>     
>>> diff --git a/fsck.ocfs2/include/pass5.h b/fsck.ocfs2/include/pass5.h
>>> new file mode 100644
>>> index 0000000..dfd27cd
>>> --- /dev/null
>>> +++ b/fsck.ocfs2/include/pass5.h
>>> @@ -0,0 +1,32 @@
>>> +/*
>>> + * pass5.h
>>> + *
>>> + * Copyright (C) 2009 Novell Corporation.  All rights reserved.
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> + * modify it under the terms of the GNU General Public
>>> + * License as published by the Free Software Foundation; either
>>> + * version 2 of the License, or (at your option) any later version.
>>>       
>> 	We generally use GPL version 2 only, but you are welcome to
>> license this 2-or-later.  I only mention this because...
>>
>>     
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>> + * General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public
>>> + * License along with this program; if not, write to the
>>> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>>> + * Boston, MA 021110-1307, USA.
>>>       
>> 	Can you check http://kernel.us.oracle.com/~smushran/license.txt
>> and update your header?  The last paragraph is no longer recommended by
>> the FSF, and we'd love for this header to have the emacs/vim lines at
>> the top.
>>     
>   I've just copy-pasted the header from pass4.h :) I'll happily update it
> but the server you referenced doesn't seem to exist anymore.
>   
You can copy/paste from libocfs2/xattr.c. It should have the right one.

Regards,
Tao
