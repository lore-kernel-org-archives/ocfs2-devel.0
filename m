From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 15 Dec 2014 21:35:46 -0800
Subject: [Ocfs2-devel] ocfs2-tools repository and documentation
In-Reply-To: <548F2CA6.4060707@citrix.com>
References: <54874E4C.8040006@citrix.com> <548D3B1E.5030309@suse.de>
	<548F2CA6.4060707@citrix.com>
Message-ID: <548FC4B2.30308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn, Germano

I have updated ocfs2-tools git repo with latest fixes :)

Germano,

following documentation is available for OCFS2

http://docs.oracle.com/cd/E37670_01/E37355/html/ol_ocfs2.html
http://www.oracle.com/us/technologies/linux/025995.htm
https://oss.oracle.com/projects/ocfs2/dist/documentation/v1.8/ocfs2-1_8_2-manpages.pdf
https://oss.oracle.com/projects/ocfs2/documentation/


On 12/15/2014 10:47 AM, Germano Percossi wrote:
> Hi Goldwyn,
>
> Thanks for your answer. I will have a look at your code.
> I just want to be sure that the source code I am looking at
> is the latest one to avoid fixing things that maybe have been already
> fixed elsewhere.
>
> Same is true for documentation and package repositories.
> If I could have links to the latest, no matter how old and not
> maintained, documentation and repository, it would be helpful,
> as well.
>
> Do you know of any other distro, besides Suse, maintaining a stack
> of patches?
>
> Cheers,
> Germano
>
> On 14/12/14 07:24, Goldwyn Rodrigues wrote:
>> Yes, if you don't count the last 2 patches, it is more close to 3 years
>> now ;)
>>
>> Since the patches were not being updated. I started maintaining an
>> alternate repository where I am putting all the bugs reported at SUSE:
>>
>> https://github.com/goldwynr/ocfs2-tools
>>
>> Branch suse-fixes has the fixes found by SUSE over the "upstream" branch.
>>
>> Branch nocontrold has the patches for the feature of doing away with
>> ocfs2_controld to work with the latest corosync/pacemaker stack. Patches
>> for the kernel are already in the kernel but the ones in the tools need
>> some review.
>>
>> I had a mail conversation with Srini and he has promised to update the
>> upstream branch soon.
>>
>> Regards,
>>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
