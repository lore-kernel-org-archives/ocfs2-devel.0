From: Andrew Beekhof <abeekhof@suse.de>
Date: Wed, 19 Nov 2008 09:49:24 +0100
Subject: [Ocfs2-devel] New OCF edition of o2cb
In-Reply-To: <20081118231517.GD10451@mail.oracle.com>
References: <02292B9D-C88D-4262-AADF-3820512DC60E@suse.de>
	<20081118231517.GD10451@mail.oracle.com>
Message-ID: <1E49F7AE-BF12-4D12-8692-730BFDC84341@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On Nov 19, 2008, at 12:15 AM, Joel Becker wrote:

> On Tue, Nov 18, 2008 at 11:30:18AM +0100, Andrew Beekhof wrote:
>> Here is an OCF-compliant edition of o2cb for use by cluster  
>> managers to
>> control userspace-based OCFS2 installations.
>> It defaults to using the pcmk stack, but can also be configured to  
>> use
>> cman.
>
> 	I'm guessing this is basically the same as o2cb.init, but using
> configuration and constants used by OCF?  Coolness.

right

>
> 	Why does it need to 'default' to any stack?  o2cb.init gets the
> answer out of /etc/sysconfig/o2cb, and I would assume OCF would have a
> similar sort of thing.

Actually not.

OCF expects any options to be supplied in the form of environment  
variables (which are specified as part of the cluster resource  
definition and the list of supported ones is described in the script's  
metadata).  Options can also be mandatory or optional (also indicated  
in the metadata).

eg. this is what an IP address looks like in a cluster configuration:

         <primitive id="myFirstIP" class="ocf" type="IPaddr"  
provider="heartbeat">
           <instance_attributes id="attrs-myFirstIP">
               <nvpair id="netmask-myFirstIP" name="cidr_netmask"  
value="32"/>
               <nvpair id="ip-myFirstIP" name="ip" value="1.2.3.4"/>
           </instance_attributes>
         </primitive>

The cluster manager then translates that into:
    OCF_RESKEY_ip=1.2.3.4 OCF_RESKEY_netmask=32 /usr/lib/ocf/ 
resource.d/heartbeat/IPaddr {action}
where {action} is one of the usual suspects: start, stop, monitor, etc

Note that we didn't specify a value for "nic", so the script will  
figure out which interface to use.
We could have also left out the netmask and the script would have used  
the one from the interface.

(Tangent: Obviously the above XML is in Pacemaker syntax, but although  
cman uses different syntax, it effectively does the same thing)

Applying that to the current topic, the cman version of the resource  
would be:

         <primitive id="o2cb-cman" class="ocf" type="o2cb"  
provider="ocfs2">
           <instance_attributes id="o2cb-cman-attrs">
               <nvpair id="cman-stack" name="stack" value="cman"/>
           </instance_attributes>
         </primitive>

and the Pacemaker version (which can use the advertised default for  
"stack") would be:
         <primitive id="o2cb-pcmk" class="ocf" type="o2cb"  
provider="ocfs2"/>

If I had knowledge of cman, its likely I could automatically work out  
the "right" stack to use instead of just defaulting to pcmk.
But for the initial cut, I thought it best to provide a manual setting  
(that happened to favor the author :-) rather than an automatic one  
that was probably only half right.

Does that all make sense?

>
>
>> I believe the correct location for it is vendor/common
>
> 	Yes.
>
>> Oh, and if the license is an issue, it can be changed.
>
> 	GPLv2 is exactly what we use.  You can remove the paragraph
> about "If you didn't receive a copy of the GPL"; the FSF has moved,  
> and
> they recommend removing that paragraph.  Regarding Copyright, much  
> of the
> code comes from o2cb.init, which is Copyright Oracle 2005,2008.   
> Please
> add that copyright.

Np.
Do you want to fix that when you commit or shall I resend?
