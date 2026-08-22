In the world of Vagrant, there actually is no vagrant down command\! If your local agent tries to use that syntax, it will throw an error. The two primary teardown commands you will use are **vagrant halt** and **vagrant destroy**. \[1\]

Because your alias proxies every command directly to your host's native KVM/Libvirt engine, running a teardown via the alias cleanly triggers your host kernel to unload the virtual machine, release allocated RAM, and wipe the virtual disks.

Here is exactly how the Vagrant cleanup lifecycle works and how to handle it through the containerized alias.

## ---

**1\. The Teardown Commands**

* **vagrant halt (The "Turn Off" Command)**  
  Safely shuts down the guest operating system inside the KVM virtual machine.  
  * *What it does:* The VM stops running, and your host reclaims 100% of the allocated RAM and CPU.  
  * *The State:* The virtual hard drive image remains intact on your system disk. The next time you type vagrant up, it boots back up in seconds with all your files and installed apps exactly where you left them. \[2, 3\]  
* **vagrant destroy (The "Complete Purge" Command)**  
  This is your absolute clean-slate command.  
  * *What it does:* It stops the VM if it's running and **completely deletes the virtual hard drive files** from your storage pool.  
  * *The State:* The environment is entirely erased. Running vagrant up after a destroy will create a brand-new, empty virtual machine from your baseline cached box image. \[4, 5, 6, 7, 8\]

## ---

**2\. Manual Emergency Cleanup: The virsh Safety Net**

Because the alias forwards commands to your host's native hypervisor, the virtual machines are registered directly with your local Linux Libvirt system. If you ever delete your project folder containing your Vagrantfile, or if Molecule crashes mid-test, the container might leave a "ghost" virtual machine running in the background on your host hardware.

You can inspect and nuke these directly from your bare-metal CachyOS terminal using **virsh** (the native Linux virtualization CLI tool):

## **Step 1: Check for Running/Ghost VMs**

`virsh list --all`

*You will see a list of active virtual machines. Vagrant-created VMs are easily identifiable because their names typically start with your project directory name.* \[9, 10, 11\]

## **Step 2: Force-Kill a Stuck VM**

If a VM is frozen or won't stop, yank the virtual power cord:

`virsh destroy <name_of_vm>`

## **Step 3: Completely Erase the Ghost VM and Disk**

To unregister the VM from your system and wipe its storage footprint off your hard drive permanently:

`virsh undefine <name_of_vm> --remove-all-storage`

## ---

**3\. Cleaning the Image Box Cache**

When you run vagrant init archlinux/archlinux, Vagrant downloads a master compressed image file (called a "box") and saves it to your host's disk under \~/.vagrant.d (thanks to our bind-mount flag). \[12\]

These boxes are global baselines. They don't take up any CPU or RAM when idle, but over time, as you test different OS versions, they can hog disk space. \[13\]

* **To see what boxes are cached on your disk:**  
  `vagrant box list`

* **To delete an old or unused base box from your cache:**  
  `vagrant box remove archlinux/archlinux`

* **To completely wipe out the entire caching folder manually:**  
  `rm -rf ~/.vagrant.d`

## **The Clean Takeaway**

For your daily local agent workflow, simply use **vagrant halt** when you want to take a break and pause your work, and use **vagrant destroy** when you are completely finished testing a playbook and want to wipe out the sandbox to reclaim your disk space\!

\[1\] [https://codingnetworker.com](https://codingnetworker.com/2015/09/use-vagrant-to-run-the-python-examples/)  
\[2\] [https://www.jeeviacademy.com](https://www.jeeviacademy.com/installing-vagrant/)  
\[3\] [https://www.geeksforgeeks.org](https://www.geeksforgeeks.org/operating-systems/what-is-vagrant/)  
\[4\] [https://www.progress.com](https://www.progress.com/blogs/vagrant-commands-you-need-to-know)  
\[5\] [https://devopslibrary.com](https://devopslibrary.com/lessons/what-is-vagrant/)  
\[6\] [https://friendsofvagrant.github.io](https://friendsofvagrant.github.io/v2/docs/getting-started/teardown.html)  
\[7\] [https://www.youtube.com](https://www.youtube.com/watch?v=PaI70u-DqXM)  
\[8\] [https://learn.userfrosting.com](https://learn.userfrosting.com/4.4/installation/environment/homestead)  
\[9\] [https://discuss.hashicorp.com](https://discuss.hashicorp.com/t/where-vagrant-stores-the-virtual-disk/62181)  
\[10\] [https://blog.everpuredata.com](https://blog.everpuredata.com/purely-educational/docker-vs-vagrant/)  
\[11\] [https://phoenixnap.com](https://phoenixnap.com/kb/vagrant-beginner-tutorial)  
\[12\] [https://ostechnix.com](https://ostechnix.com/how-to-delete-outdated-vagrant-boxes-in-linux/)  
\[13\] [https://www.abhishek-tiwari.com](https://www.abhishek-tiwari.com/my-vagrant-workflow/)