From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 19 Nov 2008 10:10:13 -0800
Subject: [Ocfs2-devel] New OCF edition of o2cb
In-Reply-To: <1E49F7AE-BF12-4D12-8692-730BFDC84341@suse.de>
References: <02292B9D-C88D-4262-AADF-3820512DC60E@suse.de>
	<20081118231517.GD10451@mail.oracle.com>
	<1E49F7AE-BF12-4D12-8692-730BFDC84341@suse.de>
Message-ID: <20081119181012.GA16192@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 19, 2008 at 09:49:24AM +0100, Andrew Beekhof wrote:
>> 	Why does it need to 'default' to any stack?  o2cb.init gets the
>> answer out of /etc/sysconfig/o2cb, and I would assume OCF would have a
>> similar sort of thing.
>
> Actually not.

<snip>

>         <primitive id="o2cb-cman" class="ocf" type="o2cb"  
> provider="ocfs2">
>           <instance_attributes id="o2cb-cman-attrs">
>               <nvpair id="cman-stack" name="stack" value="cman"/>
>           </instance_attributes>
>         </primitive>
>
> and the Pacemaker version (which can use the advertised default for  
> "stack") would be:
>         <primitive id="o2cb-pcmk" class="ocf" type="o2cb"  
> provider="ocfs2"/>
>
> If I had knowledge of cman, its likely I could automatically work out  
> the "right" stack to use instead of just defaulting to pcmk.
> But for the initial cut, I thought it best to provide a manual setting  
> (that happened to favor the author :-) rather than an automatic one that 
> was probably only half right.

	Well, if you are just trying to figure out the value to stick in
/sys/fs/ocfs2/cluster_stack, the answer is "cman", because I wrote those
bits in ocfs2-tools ;-)

> Np.
> Do you want to fix that when you commit or shall I resend?

	Why don't you resend so we don't have me stomping on it?

Thanks,
Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
