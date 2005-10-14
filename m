From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Fri Oct 14 16:31:05 2005
Subject: [Ocfs2-devel] ocfs2's bmap output
In-Reply-To: <1129304929.8092.50.camel@localhost.localdomain>
References: <1129268016.8092.28.camel@localhost.localdomain>	<20051014061251.GE9943@ca-server1.us.oracle.com>
	<1129304929.8092.50.camel@localhost.localdomain>
Message-ID: <4350239C.4070103@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Not high in the priority... but it's on the list.

Shaya Potter wrote:

>On Thu, 2005-10-13 at 23:12 -0700, Mark Fasheh wrote:
>  
>
>>Hi,
>>
>>On Fri, Oct 14, 2005 at 01:33:35AM -0400, Shaya Potter wrote:
>>    
>>
>>>I'm guessing this is because of its use of extents, and probably means
>>>I've screwed myself in trying to use bmap in this way.  Is that a
>>>correct assumption?  Is there any other interface into OCFS2 to tell if
>>>a block is a "blank" sparse area?
>>>      
>>>
>>Unfortunately, no. Since OCFS2 doesn't currently support sparse files, the
>>"holes" created are actually allocated and filled with zeros. Once
>>allocated, they'll look no different from other file data.
>>    
>>
>
>a related question then.  Is sparse file support not planned at all for
>OCFS2, or just "not currently" supported.
>
>thanks.
>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>  
>
