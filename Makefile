smoke: test

test:
	find tests -name \*.pp | xargs -n 1 -t puppet apply --noop --modulepath=tests/modules

vm:
	vagrant up
